# Garlic - Googlebooks Api Reading LIst Creator

Garlic is a command-line utility that allows you to use the Google Books API to search for books and construct a reading list.

## Overview and Rationale

The purpose of this project was to experiment with a few new technologies, specifically:

- [Micronaut](https://micronaut.io) - A modern, JVM-based, full-stack framework for building modular, easily testable microservice and serverless applications. 
- [Picocli](https://picocli.info/) - a one-file framework for creating Java command line applications with almost zero code.
- [GraalVM](https://www.graalvm.org) - a high-performance runtime that provides significant improvements in application performance and efficiency which is ideal for microservices. 

## Installation

Garlic is designed to be built and run as a native binary, using GraalVM.  If you don't have GraalVM installed, checkout [the project documentation on how to install it](https://www.graalvm.org/getting-started/#install-graalvm), and then come back.Check if you have native image installed:

    gu list 
    ComponentId              Version             Component name      Origin 
    --------------------------------------------------------------------------------
    graalvm                  20.1.0              GraalVM Core        


If not, use the GraalVM component updater to install native image:

    gu install native-image

Then use `gradle` to create a shadow Jar:

    ./gradlew --no-daemon assemble
    
And finally create a native binary by running `native-image` against the Jar you just created:

    native-image --no-server -cp build/libs/garlic-VERSION.jar 
    
You should now see a binary called garlic in the current working directory.  If you inspect it, you'll see it's executable, so go ahead and test it with `garlic --version`.

If you want to use this globally, simply copy the binary to somewhere in your shell's search path, such as `/usr/local/bin`

---
**NOTE**

Although GraalVM can produce a binary which will run on Microsoft Windows, at present only Linux and UNIX derivatives are supported.

---

## Usage

Garlic has three subcommands for creating reading lists:

- `garlic search`
- `garlic save`
- `garlic view`

### Garlic Search

The search subcommand sends a query to the Google Books API, and returns up to the top five results.

#### Search Syntax

The search command will consider all text after the word search to be the query to send to Google.  If you wish to search for a specific phrase, you can enclose your keywords in quotation marks:

    garlic search "bonsai tree"
    
If you do not include quotation marks, the API will consider each space-separated string to be a keyword.

Punctuation is valid - only a pair of quotation marks are considered semantically significant.

The Google API will truncate queries longer than roughly 2000-2100 characters in length, so for this reason, search queries greater than 2000 characters in length will be rejected.

#### Results

Garlic will return the top five results, with a numerical index, for example:

    1. How to Play the Sicilian Defence, David N. Levy, Batsford
    2. How to Beat the Sicilian Defence, Gawain Jones, Cadogan
    3. Sicilian Defence: Najdorf Variation, John Nunn, Batsford
    4. The Sicilian Dence, Lubomir Ftacnik, Quality Chess
    5. The Najdorf Variation of the Sicilian Defence, Efim Geller, R.H.M. Press

The results will always include the title, the author, and the publisher.

If there are fewer than five results, but at least one result returned by the API, those results will be returned, as above.

If the query yields no results, no results will be shown.

### Garlic Save

Garlic is designed to allow the user to accumulate a reading list, by selecting one of the returned results, and asking Garlic to save it.

After running `garlic search`, to save one of the returned results to a local reading list, use the `garlic save` subcommand.

In the above example, if the user were to run:

    garlic save 3
    
Then John Nunn's seminal book on the Najdorf variation of the Sicilian Defence would be saved to the user's local reading list.

A reading list will be stored in the home directory of the user running the `garlic` command.

Garlic only saves one book from a result set, by specification.  The `save` subcommand also only ever refers to the most recent search, so if the user searches once for `The Infancy Narratives of Matthew and Luke`, and subsequently on `The Advantages of Barefoot Running`, any save command will only save the specified result from the barefoot running query.

---
**Implementation note**

Garlic will create a `.garlic` directory in the user's home directory, in which search results are cached, and the reading list is stored. 

---

### Garlic View

In order to view the reading list, the `view` subcommand is provided.

This will print the current state of the reading list to the screen.  Reading lists are tied to the user running the `garlic` command, so if the user `sns` runs `garlic search` followed by `garlic save`, and then `garlic list`, he will see his results.  However, if the user changes from `sns` to `wilfred`, the reading list compiled by the `sns` user will not be shown.

If no books have been saved to the reading list, the list will simply appear empty, and Garlic will provide helpful guidance on how to search for and save your first book.

## Contributing

Garlic is not considered to be a maintained project - its purpose was to experiment with Micronaut, Picocli, and GraalVM.  Pull requests are not invited, but you are free to fork it and experiment to your heart's content.