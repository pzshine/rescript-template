module CounterpartyConfig = %graphql(`
  subscription Counterparty($chainID: String!) {
    counterparty_chains(where :{chain_id: {_ilike: $chainID}}) @bsRecord{
    chainID: chain_id
    connections @bsRecord{
      channels @bsRecord{
        channel
        port
      }
    }
  }
  }`)

let getChainFilterList = chainID => {
  let result = CounterpartyConfig.use({chainID: chainID})
  result
}

module Styles = {
  open CssJs

  let root = style(. [backgroundColor(black), color(white), padding2(~v=px(10), ~h=px(20))])
}

@react.component
let make = () => {
  let chainSub = getChainFilterList("consumer")

  <div className=Styles.root>
    {switch chainSub {
    | {data} => {
        Js.Console.log(data)
        React.null
      }
    | _ => React.null
    }}
  </div>
}
