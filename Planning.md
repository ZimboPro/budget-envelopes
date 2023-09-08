# Planning

## Requirements

### Envelopes

 * Able to add an envelope with a name and allocated amount
 * Able to edit the envelope
 * Able to remove the envelope
 * Able to get all the envelopes
 * Able to get a envelope
 * Able to have different amounts allocated for different months
 * Able to carry over the balance of the envelope if desired

#### Model

 * ID
 * Name
 * Description
 * Amount
 * Date (Just needs to the the year and month)

### Transactions

 * Able to add an transaction with a name and allocated amount linked to a specific envelope
 * Able to edit the transaction
 * Able to remove the transaction
 * Able to get all the transactions
 * Able to get a transaction
 * If the transaction is edited to occur in a different month, then it needs to the correct envelope

#### Model

 * ID
 * Name
 * Description
 * Amount
 * Envelope ID
 * Date
