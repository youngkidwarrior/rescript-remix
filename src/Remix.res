@val external process: 'a = "process"

module RemixBrowser = {
  @module("@remix-run/react") @react.component external make: unit => React.element = "RemixBrowser"
}

type entryContext
type appLoadContext

type params = Js.Dict.t<string>

type dataFunctionArgs = {
  request: Webapi.Fetch.Request.t,
  context: appLoadContext,
  params: params,
}
type headersFunctionArgs = {
  loaderHeaders: Webapi.Fetch.Headers.t,
  parentHeaders: Webapi.Fetch.Headers.t,
  actionHeaders: Webapi.Fetch.Headers.t,
}
type headersFunction = headersFunctionArgs => Webapi.Fetch.Headers.t

type loaderFunction<'a> = dataFunctionArgs => Js.Promise.t<'a>

type actionFunction<'a> = dataFunctionArgs => Js.Promise.t<'a>

module RemixServer = {
  @module("@remix-run/react") @react.component
  external make: (~context: entryContext, ~url: string) => React.element = "RemixServer"
}

module Meta = {
  @module("@remix-run/react") @react.component
  external make: unit => React.element = "Meta"
}

module Links = {
  @module("@remix-run/react") @react.component
  external make: unit => React.element = "Links"
}

module Outlet = {
  @module("@remix-run/react") @react.component
  external make: (~context: 'a=?) => React.element = "Outlet"
}

module ScrollRestoration = {
  @module("@remix-run/react") @react.component
  external make: unit => React.element = "ScrollRestoration"
}

module Scripts = {
  @module("@remix-run/react") @react.component
  external make: unit => React.element = "Scripts"
}

module LiveReload = {
  @module("@remix-run/react") @react.component
  external make: (~port: int=?) => React.element = "LiveReload"
}

module Link = {
  @module("@remix-run/react") @react.component
  external make: (
    ~className: string=?,
    ~prefetch: [#intent | #render | #none]=?,
    ~to: string,
    ~reloadDocument: bool=?,
    ~replace: bool=?,
    ~state: 'a=?,
    ~children: React.element,
  ) => React.element = "Link"
}

module NavLink = {
  @module("@remix-run/react") @react.component
  external make: (
    ~className: string=?,
    ~prefetch: [#intent | #render | #none]=?,
    ~to: string,
    ~reloadDocument: bool=?,
    ~replace: bool=?,
    ~state: 'a=?,
    ~children: React.element,
  ) => React.element = "NavLink"
}

module Form = {
  @module("@remix-run/react") @react.component
  external make: (
    ~className: string=?,
    ~children: React.element,
    ~method: [#get | #post | #put | #patch | #delete]=?,
    ~action: string=?,
    ~encType: [#"application/x-www-form-urlencoded" | #"multipart/form-data"]=?,
    ~reloadDocument: bool=?,
    ~replace: bool=?,
    ~onSubmit: @uncurry ReactEvent.Form.t => unit=?,
  ) => React.element = "Form"
}

module Session = {
  type t
}

module SessionStorage = {
  type t

  @module("@remix-run/node")
  external getSession: (~cookieHeader: string=?) => Js.Promise.t<Session.t> = "getSession"
  @module("@remix-run/node")
  external commitSession: Session.t => Js.Promise.t<string> = "commitSession"
  @module("@remix-run/node")
  external destroySession: Session.t => Js.Promise.t<string> = "destroySession"
}

module CreateFetcherSubmitOptions = {
  type t

  @obj
  external make: (
    ~method: string=?,
    ~action: string=?,
    ~encType: string=?,
    ~replace: bool=?,
    unit,
  ) => t = ""
}

module Fetcher = {
  type t
  @send external submit: (t, 'target) => unit = "submit"
  @send
  external submitWithOptions: (t, 'target, ~options: CreateFetcherSubmitOptions.t) => unit =
    "submit"
  @send external load: (t, ~href: string) => unit = "load"

  @get external state: t => 'state = "state"
  @get external _type: t => 'a = "type"
  @get external submission: t => 'submission = "submission"
  @get external data: t => 'data = "data"

  module Form = {
    @module("@remix-run/react") @react.component
    external make: (
      ~children: React.element,
      ~method: [#get | #post | #put | #patch | #delete]=?,
      ~action: string=?,
      ~encType: [#"application/x-www-form-urlencoded" | #"multipart/form-data"]=?,
      ~reloadDocument: bool=?,
      ~replace: bool=?,
      ~onSubmit: @uncurry ReactEvent.Form.t => unit=?,
    ) => React.element = "Form"
  }
}

module Location = {
  type t

  @get external state: t => 'state = "state"
}

module Navigate = {
  type t = string => unit
}

module Transition = {
  type t

  @get external state: t => 'state = "state"
}

@module("@remix-run/node") external json: {..} => Webapi.Fetch.Response.t = "json"

@module("@remix-run/node") external redirect: string => Webapi.Fetch.Response.t = "redirect"

@module("@remix-run/react")
external useBeforeUnload: (@uncurry unit => unit) => unit = "useBeforeUnload"

@module("@remix-run/react") external useLoaderData: unit => 'a = "useLoaderData"

@module("@remix-run/react") external useFetcher: unit => Fetcher.t = "useFetcher"

@module("@remix-run/react") external useLocation: unit => Location.t = "useLocation"

@module("@remix-run/react") external useOutletContext: unit => 'a = "useOutletContext"

@module("@remix-run/react") external useParams: unit => 'a = "useParams"

@module("@remix-run/react") external useNavigate: unit => Navigate.t = "useNavigate"

@module("@remix-run/react") external useTransition: unit => Transition.t = "useTransition"

module Cookie = {
  type t

  @get external name: t => string = "name"
  @get external isSigned: t => bool = "isSigned"
  @get @return(undefined_to_opt) external expires: t => option<Js.Date.t> = "isSigned"
  @send external serialize: (t, {..}) => Js.Promise.t<string> = "serialize"
  @module("@remix-run/node") external isCookie: 'a => bool = "isCookie"

  type parseOptions = {decode: string => string}
  @send external parse: (t, option<string>) => {..} = "parse"
  @send external parseWithOptions: (t, option<string>, parseOptions) => {..} = "parse"
}

module CreateCookieOptions = {
  type t

  @obj
  external make: (
    ~decode: string => string=?,
    ~encode: string => string=?,
    ~domain: string=?,
    ~expires: Js.Date.t=?,
    ~httpOnly: bool=?,
    ~maxAge: int=?,
    ~path: string=?,
    ~sameSite: [#lax | #strict | #none]=?,
    ~secure: bool=?,
    ~secrets: array<string>=?,
    unit,
  ) => t = ""
}

@module("@remix-run/node") external createCookie: string => Cookie.t = "createCookie"
@module("@remix-run/node")
external createCookieWithOptions: (string, CreateCookieOptions.t) => Cookie.t = "createCookie"

module CreateCookieSessionStorageOptions = {
  type t

  @obj external make: (~cookie: Cookie.t) => t = ""
}

@module("@remix-run/node")
external createCookieSessionStorage: unit => SessionStorage.t = "createCookieSessionStorage"

@module("@remix-run/node")
external createCookieSessionStorageWithOptions: (
  ~options: CreateCookieSessionStorageOptions.t,
) => SessionStorage.t = "createCookieSessionStorage"
