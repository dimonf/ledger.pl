The project is inspired by excellent work of John Wiegley, ledger-cli:
 https://github.com/ledger/
Ledger.pl is written in Perl, which probably facilitates development.
The major reason for the project is however to get rid of ubiquotous 
(re)valuation of commodities, which is major feature of ledger-cli. 
While being very handy in many circumstances, it is not suitable for
situations, where historical cost shall be maintaind.

https://groups.google.com/forum/?fromgroups=#!topic/ledger-cli/f9CAsKtiyp8

The following ideas/principles are borrowed from ledger-cli:
- transaction data text file format
- application concentrates on reading data and producing reports. 
  Amendment/addition to the data file is outside the scope of program
- 'commodity' concept: everything is commodity - currencies, benzin etc.
  It appears to me as the most valuable idea in ledger-cli. This implies
  multi-currency accounting, but embraces much wider scenarios, such as 
  management accounting with transactions of non-monetary items.
- base currency (or probably, more properly, reporting currency) is not
  predefined in data file. Provided that appropriate rates are available,
  this makes it possible to prepare reports in any currency.
- traditional basic accounting data attributes, such as 'company', 'client',
  'contract', 'project', 'period', 'journal' etc. wich is common to 
  most accounting / erp applications, are not predetermined. 
- 'complex' transactions with more than one Dt and Ct
- double entry system
- autobalancing mechanism: last transaction value, if empty,  shall 
  be auto-calculated
- tags at both transaction and single record level.


Changes to the concept of ledger-cli:
- lesser flexibility of the data file. This not only simplifies parser
  mainenance, improves performance, but also facilitate readability
  of the data file. 
- separation of data from algorithms: no encolsures, prescribing
  data handling in data file.
- explicit data modification / revaluation 

I hope to go as far as to write decent vim plugin.

