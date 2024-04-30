# Requirement

**OK, here is a task #5 for you**

Implement a Web-application for the fake (random) user data generation.

The single app page allows to:
1) select region (at least 3 different, e.g. Poland, USA, Georgia or anything you prefer)
2) specify the number of error *per record* (two “linked” controls — slider 0..10 + binded number field with max value limit at least 1000)
3) define seed value and [Random] button to generate a random seed

If the user change anything, the table below automatically updates (20 records are generated again).

It's necessary to support infinite scrolling in the table (you show 20 records and if the user scroll down, you add next 10 records below — add new so called "page" = "batch of records").

The table show contain the following fields:
1) Index (1, 2, 3, ...) — no errors here
2) Random identifier — no errors here
3) Name + middle name + last name (in region format)
4) Address (in several possible formats, e.g. city+street+building+appartment or county+city+street+house)
5) Phone (again, it's great to have several formats, e.g. international or local ones)

Language of the names/address as well as phone codes/zip codes should be related to the region. You need to generate random data that looks somehow realistically. So, in Poland — Polish, in USA - English or Spanish, etc.
What is error? It's data entry error emulation. The end user specify number of errors PER RECORD. If errors = 0, there are no errors in user data. If error = 0.5, every record contains an error with probability 0.5 (one error per two records). 10 errors results in 10 errors in every record. Error number can be entered with a slider (0..10) or field  (0..1000) — they interconnected, if change one control, other is changed too.


===============================================================


Support 3 type of errors - delete character in random position, add random character (from a proper alphabet) in random position, swap near characters. Type of the error have to be chosen randomly with equal probabilities (when user specifies 1000 errors, "noisy user data" should not be too long or too short).

About seed.

Of course, you do not store RANDOM data on the server.  Вut you have to generate data on the server, not client. Single server, no "front" and "back", and no database at all (OK, you may use database for lookup tables, but you don't have to :)). When the user change seed, you have to change generated data. It's important that the seed passed to RNG algorithm is combination of the user seed and page number (so, you do not re-generate pages 1..9 when the user requests page 10). How to combine - it's not really important, some kind of sum should be enough. IMPORTANT: if I enter the same seed tomorrow I have to get the same data as today (even errors) on all pages - it's especially important for optional requirement.

Of course, if you don't use a 3rd-party libary (IT'S RECOMMENDED TO USE SOME) you will need to user lookup tables with names and surnames (separately, to be able to combine) as well as cities, etc.. They have to be large enough (more than 2 names and 10 surnames), let's say hundreds of names and several thousands of surnames. Your goal - approximately — avoid full user data duplication in ~10_000_000 records.

If user changes error amount, data (names, addresses, etc.) before error application should not be changed. If I make 1 error in John, I can get Jhon, not Simth.

And again: data should look like realistic.


===============================================================

Application should work WITHOUT registration or/and authentication.

Optional requirement: add Export to CSV button (generate the number of pages which is displayed to user currently). You have to use ready CSV-formatter (DO NOT concatenate string by hands — e.g. address easily can contain comma and semicolon of anything).

Of course, errors should be "applied" before formatting/rendering/exporting.

*How to submit the solution*

Send to p.lebedev@itransition.com:
0) Full name.
1) Link to the deployed project (you can use any 3) hosting you find suitable).
2) Link to the code.
3) Recorded video:  generation for different regions, infinite scrolling demo with 5-10 pages, change error number from 0 to 0.5, then to 5, then to 20, then to 1000 (data should be transformed to "noise"), then to 0. Change seed, demonstrate than reset seed to previous values restores data to previous state as well.

**Deadline: 04.05.2024** (the same for the rest of tasks)

YOU CAN (AND MUST) USE 3RD-PARTY LIBRARIES FOR DATA GENERATION (check some Faker ports).

