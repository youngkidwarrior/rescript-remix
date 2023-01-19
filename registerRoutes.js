'use strict';

var Fs = require("fs");
var Path = require("path");
var Js_exn = require("rescript/lib/js/js_exn.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Belt_MutableMapString = require("rescript/lib/js/belt_MutableMapString.js");

function filenameToSegment(name) {
  var segment = name.split("").reduce((function (acc, $$char) {
          var match = acc.state;
          var exit = 0;
          switch ($$char) {
            case "." :
                if (match === 0) {
                  return {
                          segment: acc.segment + "/",
                          state: acc.state
                        };
                }
                exit = 2;
                break;
            case "[" :
                if (match === 1) {
                  return {
                          segment: acc.segment,
                          state: /* InsideEscape */4
                        };
                }
                if (match === 0) {
                  return {
                          segment: acc.segment,
                          state: /* SawOpenBracket */1
                        };
                }
                exit = 2;
                break;
            case "]" :
                switch (match) {
                  case /* Normal */0 :
                      exit = 2;
                      break;
                  case /* SawOpenBracket */1 :
                      return {
                              segment: acc.segment + "*",
                              state: /* Normal */0
                            };
                  case /* SawCloseBracket */2 :
                  case /* InsideParameter */3 :
                      return {
                              segment: acc.segment,
                              state: /* Normal */0
                            };
                  case /* InsideEscape */4 :
                      return {
                              segment: acc.segment,
                              state: /* SawCloseBracket */2
                            };
                  
                }
                break;
            case "_" :
                if (match === 0) {
                  return {
                          segment: "",
                          state: acc.state
                        };
                }
                exit = 2;
                break;
            default:
              exit = 2;
          }
          if (exit === 2 && match < 3) {
            switch (match) {
              case /* Normal */0 :
                  break;
              case /* SawOpenBracket */1 :
                  return {
                          segment: acc.segment + ":" + $$char,
                          state: /* InsideParameter */3
                        };
              case /* SawCloseBracket */2 :
                  return {
                          segment: acc.segment + "]" + $$char,
                          state: /* InsideEscape */4
                        };
              
            }
          }
          return {
                  segment: acc.segment + $$char,
                  state: acc.state
                };
        }), {
        segment: "",
        state: /* Normal */0
      }).segment;
  if (name.startsWith("_")) {
    return "_" + segment;
  } else if (segment === "index") {
    return "";
  } else {
    return segment;
  }
}

function buildRoutesForDir(path) {
  var routes = Belt_MutableMapString.make(undefined);
  var files = Fs.readdirSync(Path.join("app", path));
  files.forEach(function (file) {
        var fileInfo = Path.parse(file);
        var isDirectory = Fs.statSync(Path.join("app", path, file)).isDirectory();
        if (!(isDirectory || fileInfo.ext === ".js")) {
          return ;
        }
        var segment = filenameToSegment(isDirectory ? fileInfo.base : fileInfo.name);
        var mapping = Belt_MutableMapString.getWithDefault(routes, segment, {
              file: undefined,
              nested: undefined
            });
        if (isDirectory) {
          mapping.nested = Caml_option.some(buildRoutesForDir(Path.join(path, segment)));
        } else {
          mapping.file = Path.join(path, file);
        }
        return Belt_MutableMapString.set(routes, segment, mapping);
      });
  return routes;
}

function registerBuiltRoutes(routes, defineRoute, segmentsOpt, param) {
  var segments = segmentsOpt !== undefined ? segmentsOpt : [];
  return Belt_MutableMapString.forEach(routes, (function (segment, definition) {
                var match = definition.file;
                var match$1 = definition.nested;
                if (match === undefined) {
                  if (match$1 !== undefined) {
                    return registerBuiltRoutes(Caml_option.valFromOption(match$1), defineRoute, segments.concat([segment]), undefined);
                  } else {
                    return Js_exn.raiseError("Invariant error");
                  }
                }
                if (match$1 === undefined) {
                  return defineRoute(segments.concat([segment]).join("/"), match, {
                              index: segment === ""
                            });
                }
                var nested = Caml_option.valFromOption(match$1);
                var isPathlessRoute = segment.startsWith("_");
                return defineRoute(isPathlessRoute ? undefined : segments.concat([segment]).join("/"), match, (function (param) {
                              return registerBuiltRoutes(nested, defineRoute, undefined, undefined);
                            }));
              }));
}

function registerRoutes(defineRoute) {
  return registerBuiltRoutes(buildRoutesForDir("res-routes"), defineRoute, undefined, undefined);
}

exports.registerRoutes = registerRoutes;
/* fs Not a pure module */
