# Cypress on AWS lambda example

A demonstration of how to run cypress on AWS lambda, using chromium.

I've tried to make this as minimal as possible, but there might be some ways this could be simplified further.

I wasn't able to get cypress's embedded electron to work on lambda.

## Building and running this example yourself
`build-and-local-test.sh` will build the container image, and test it locally, 
similar(although not identical) to how it would be run from lambda.

Once the image is built you will have to push it to an ECR repo, and create your lambda function.

A lambda with 2GB of ram seems to work ok.


## Further possible improvements/simplifications

If cypress supported being installed, and running without electron, it would reduce the size of the image by about half a gigabyte.  

If cypress supported running from a read-only file-system, the lambda handler code would be simpler.  

It's possible that some of the flags passed to chrome aren't necessary, although I haven't tried all combinations.

It might be possible to reduce the image size by omitting some of the system dependencies, or installing chromium differently.