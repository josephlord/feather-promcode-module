# feather-promocode-module

This is an add on module for the [Feather CMS](https://github.com/FeatherCMS/feather) that allows you to use the admin console to create offers and add promocodes. The promo codes are then consumed one at a time via an API endpoint to distribute single use codes.

This is very lightly tested and only just being deployed for the first time on 31st Jan 2021.

## Why

I want to distribute App Store promo codes for my new app [Fast Lists Sync](https://human-friendly.com/fast-lists-sync/) within my older [Fast Lists](https://www.human-friendly.com/fast-lists) app and I couldn't find a service to do the job of handing out unique codes from a pool on each request

## Installation

1) Fork Feather CMS - Get it building / running as standard and ensure you can reach the admin console.
2) Add this package to the dependencies in the Package.swift file.
`.package(url: "https://github.com/josephlord/feather-promocode-module", from: "0.0.4"),`
3) Run the `PromoCodeBuilder()` with the other builders in the `feather.configure` method of `Sources/Feather/main.swift` (you will need to import PromoCode)
After steps 2 and 3 your changes should look like [this PR](https://github.com/josephlord/hfWebsite2020/pull/2/files) (ignore Package.resolved, something similar should be generated when your packages are updated.
4) Build and run as you did in step 1 making sure that packages are installed in the process.

## Admin

You should see the "Promo Codes" section. That gives access to the list of offers (which will initially be empty). There is a plus button to add an offer. Set the name (which will be in the URL you use to access the promos), the description and an expiry date "y-MM-dd" e.g. "2021-12-16" and then you can paste in a comma separated list of promo codes into the codes field.

Note that large numbers of promo codes do upload but the webform makes the browser struggle during pasting, room for improvement in how this is handled but for now be patient. Firefox coped better than Safari when I was pasting 20,000 codes but then other form edits choked so create the offer first or at least fill in the other fields.

## Getting codes

The endpoint wil be as follows. It will return a random promo code for the named over and include information about the offer
as you have set up. That code will be removed from the database within the transaction to access it so you can be sure (if your database supports transactions properly) that there will never be a case where two users access the same code.
`/api/promo/code/\(offerName)/take/`

# Warnings

No tests, not yet used at scale, only used at all on Sqlite (and it has raw SQL for the listings screen so may break for others although it is fairly vanila SQL). Suspect it will not work on MongoDB. May not be well supported into the future when my itch is scratched. Use at your own risk.

## Want to help

Great. It may be time is more valuably spent on Feather development itself, the project leader has some starter tasks to get into.

If you want to do something with PromoCodes in particular I think changing the form so that it is a file upload field for the codes would be the obvious improvement.

The other thing that would likely be useful for many is if there was a public webpage to get the code rather than just an API call. That wasn't needed for my use case so I haven't looked into it. A standalone page should be fairly easy, there might be a more advanced option to create a widget that can be embedded in pages although that may consume many codes that the person viewing the site may not even look at.

Any code review or comments clearly welcome too.
