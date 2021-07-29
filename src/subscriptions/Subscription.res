type connection_t = {connection_id: string}

type counterparty_t = {
  chainID: string,
  connections: array<connection_t>,
}

module IncomingPacketConfig = %graphql(`
  subscription IncomingPackets {
    incoming_packets {
      acknowledgement
    }
  }
`)

module CounterpartyConfig = %graphql(`
  subscription Counterparty($chainID: String) {
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

module TxCountConfig = %graphql(`
  subscription TransactionsCount {
    transactions_aggregate @bsRecord{
      aggregate {
        count
      }
    }
  }`)

let getPacket = () => {
  let result = IncomingPacketConfig.use()

  result
}

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
  let chainSub = getChainFilterList(None)
  let pageSize = 5
  let latest5BlocksSub = BlockSub.getList(~pageSize, ~page=1, ())

  <div className=Styles.root>
    {switch latest5BlocksSub {
    | {data: Some({blocks})} => {
        Js.log(blocks[0].timestamp)
        React.null
      }
    | _ => React.null
    }}
  </div>
}
