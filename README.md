# feather-promocode-module

This is an add on module for the Feather CMS that allows you to use the admin console to create offers and add promocodes. The promo codes are then consumed one at a time via an API endpoint to distribute single use codes.

This is very lightly tested and only just being deployed for the first time on 31st Jan 2021

## Installation

1) Fork Feather CMS - Get it building / running as standard and ensure you can reach the admin console.
2) Add this package to the dependencies in the Package.swift file.
`.package(url: "https://github.com/josephlord/feather-promocode-module", from: "0.0.4"),`
3) Run the `PromoCodeBuilder()` with the other builders in the `feather.configure` method of `Sources/Feather/main.swift` (you will need to import PromoCode)
4) Build and run

## Admin

You should see the "Promo Codes" section. That gives access to the list of offers (which will initially be empty). There is a plus button to add an offer. Set the name (which will be in the URL you use to access the promos), the description and an expiry date "y-MM-dd" e.g. "2021-12-16" and then you can paste in a comma separated list of promo codes into the codes field.

## Getting codes

The endpoint wil be as follows. It will return a random promo code for the named over and include information about the offer
as you have set up. That code will be removed from the database within the transaction to access it so you can be sure (if your database supports transactions properly) that there will never be a case where two users access the same code.
`/api/promo/code/\(offerName)/take/`

# Warnings

No tests, not yet used at scale, only tested on Sqlite (and it has raw SQL for the listings screen so may break for others although it is fairly vanila SQL). Suspect it will not work on MongoDB. May not be well supported into the future when my itch is scratched. Use at your own risk.
