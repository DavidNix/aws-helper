# AWS Helper
### A service object for Rails apps.

A simple service object to interact with AWS.  Currently, it only supports simple operations with S3.  However, it can be easily extended to support other AWS services.

## Setup
1.  Set up AWS ENV variables:

    # http://docs.aws.amazon.com/AWSRubySDK/latest/frames.html
    export AWS_ACCESS_KEY_ID='...'
    export AWS_SECRET_ACCESS_KEY='...'
    export AWS_REGION='us-west-2'

2.  Modify the DEFAULT_S3_BUCKET to fit your own needs.
3.  Add any new serives in `self.new_session`.  Also expire memoized instance variables in `self.refresh_session_if_expired`.
4.  Place this class in app/services, or any directory that's autoloaded in your Rails app.

## TO DOs
* Make thread safe.
* Perhaps use a connection pool (which should take care of thread safety).