@react.component
let make = () =>
  <ApolloClient.React.ApolloProvider client=Apollo.client>
    <h4> {"Subcription"->React.string} </h4> <Subscription />
  </ApolloClient.React.ApolloProvider>
