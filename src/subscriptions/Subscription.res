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
  // let chainSub = getChainFilterList(None)
  let pageSize = 5
  let (page, setPage) = React.useState(_ => 1)
  let latest5BlocksSub = BlockSub.getList(~pageSize, ~page, ())
  let blockSub = BlockSub.get(~height=10030000, ())

  let next = () => setPage(prev => prev + 1)

  <div className=Styles.root>
    {
      // {switch latest5BlocksSub {
      // | {data: Some({blocks}), loading: false} => {
      //     Js.log(blocks[0].timestamp)
      //     <div>
      //       {blocks[0].timestamp |> MomentRe.Moment.format("YYYY-MM-DD HH:mm:ss") |> React.string}
      //     </div>
      //   }
      // | {loading: true, data: Some(x)} => {
      //     Js.log2("Loading with Some", x)
      //     <div> {"Loading with Some" |> React.string} </div>
      //   }
      // | {loading: true, data: None} => {
      //     Js.log("Loading with None")
      //     <div> {"Loading with None" |> React.string} </div>
      //   }
      // | {error: Some(error)} => {
      //     Js.log(error)
      //     React.null
      //   }
      // | {loading: false, data: None, error: None} => {
      //     Js.log("No data")
      //     <div> {"No data" |> React.string} </div>
      //   }
      // }}
      // <button onClick={_ => next()}> {"Next" |> React.string} </button>
      switch blockSub {
      | {data: Some({blocks_by_pk}), loading: false} => {
          Js.log2("Data is ", blocks_by_pk)
          React.null
        }
      | {loading: true, data: Some(x)} => {
          Js.log2("Loading with Some", x)
          <div> {"Loading with Some" |> React.string} </div>
        }
      | {loading: true, data: None} => {
          Js.log("Loading with None")
          <div> {"Loading with None" |> React.string} </div>
        }
      | {error: Some(error)} => {
          Js.log(error)
          React.null
        }
      | {loading: false, data: None, error: None} => {
          Js.log("No data")
          <div> {"No data" |> React.string} </div>
        }
      }
    }
  </div>
}
