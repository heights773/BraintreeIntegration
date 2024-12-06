# README

Steps needed to run application:

# SET UP
* install Xcode, if not already installed, from the App Store on your Mac
* install PHP, if not already installed, using this tutorial:
    https://kinsta.com/blog/install-php/
* PHP version: 8.1.10
    To check the PHP version being used type `php -v` into the terminal

* Gateway configuration:
  To configure the gateway, you will need to enter the gateway credentials from your Braintree account.
  These will be entered in the following files along with their respective path:
        client_token.php – `BT_Integration/BT_Integration/client_token`
        create_transaction – `BT_Integration/BT_Integration/create_transaction`
        transaction_search – `BT_Integration/BT_Integration/transaction_search`
      
  These credentials can be found by following the instructions listed here: https://articles.braintreepayments.com/control-panel/important-gateway-credentials#api-credentials
  
* Sandbox set up:
    The sandbox this was tested in was set up with the following rules:
    1. AVS: Postal Code not required
    2. AVS: Street Address not required
  Any connecting sandbox will want to apply the same rules otherwise an error will be shown displaying the transaction has failed.
  
  RUNNING THE APP
* Navigate to the apps location in terminal by doing the following: `cd app_file_path/BT_Integration`
* Starting the app server: run 'php -S localhost:8000 -t BT_Integration' in terminal
    One thing to note, if you get the error message 'Directory BT_Integration does not exist.' be sure you are not at the path 'BT_Integration/BT_Integration' If so, you can back out by typing 'cd ..' in the terminal.

  Have fun testing the checkout page!
  
* Test cards can be found at: https://developer.paypal.com/braintree/docs/reference/general/testing#credit-card-numbers
  
# WHERE TO LOOK
* server-side code
    `BT_Integration/BT_Integration/client_token`
        This is where the client token generated.
        Gateway credentials can be entered.
        
    `BT_Integration/BT_Integration/create_transaction` 
        This is where the transaction is created.
        
    `BT_Integration/BT_Integration/transaction_search`
        This is where we search our gateway for our transaction history.
        Format the return value for our table view to display the transaction ID, amount and card type.

* client-side code
    `BT_Integration/BT_Integration/ViewController`
        The main checkout page
        This is where the client-side styling is housed.
        The checkout form, client token fetching, and transaction create are all housed.
  
    `BT_Integration/BT_Integration/HistoryTableView`
        The transaction history view
        This is where you can see all the transactions made within the last 3 months
        Transaction search and client-side styling can be found here.

# Notes
* paymentMethod()->create([])
    This integration does not make use of paymentMethod()->create([]) on the server due to being able to acheive this on the client using card.shouldValidate = true. If gateway credentials are entered in and a transaction is made, when navigating to your Vault, via the Control Panel, a new customer will have been entered.

* Expiration Date text field
    The expiration date text field must be fully entered and entered as mm/yy. Otherwise an error will be thrown in Xcode stating: 
        Thread 1: Fatal error: Index out of range. 
    Ideally, this would be formatted so that a forward slash is inserted automatically and the input is via a number pad keyboard.

