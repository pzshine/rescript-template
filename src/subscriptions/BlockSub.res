module Date = {
  type t = MomentRe.Moment.t
  let parse = json => json->GraphQLParser.timestamp

  let serialize = date => "empty"->Js.Json.string
}

type internal_t = {timestamp: MomentRe.Moment.t}

module MultiConfig = %graphql(`
  subscription Blocks($limit: Int!, $offset: Int!) {
    blocks(limit: $limit, offset: $offset, order_by: [{height: desc}]) @ppxAs(type: "internal_t"){
      timestamp @ppxCustom(module: "Date")
    }
  }
`)

let getList = (~page, ~pageSize, ()) => {
  let offset = (page - 1) * pageSize
  let result = MultiConfig.use({limit: pageSize, offset: offset})

  result
}
