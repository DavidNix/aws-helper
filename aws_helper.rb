class AWSHelper

  DEFAULT_S3_BUCKET = "your-default-s3-bucket"

  # pass force_new: true to force a new session
  # add new AWS Services here
  # http://docs.aws.amazon.com/AWSRubySDK/latest/frames.html
  def self.new_session(aws_service, opts={})
    refresh_session_if_expired(opts)
    @session ||= AWS::STS.new.new_session
    case aws_service
      when :s3
        @s3 ||= AWS::S3.new(@session.credentials)
      else
        raise "Unknown AWS Service #{aws_service.to_s}.  Add new ones in lib/aws_helper."
    end
  end

  def self.session_information
    {session: @session, s3: @s3, transcoder: @transcoder}
  end

  # S3 methods
  def self.s3_file_exists?(filepath, bucket=DEFAULT_S3_BUCKET, s3=nil)
    s3 = new_session(:s3) if s3.nil?
    begin
      s3.buckets[bucket].objects[filepath].exists?
    rescue AWS::S3::Errors::NoSuchKey => e
      false
    end
  end

  def self.move_to_new_bucket(source = {}, destination = {})
    s3 = new_session(:s3)
    movable_object = s3.buckets[source[:bucket]].objects[source[:filename]]
    movable_object.move_to(destination[:filename], :bucket_name => destination[:bucket])
  end

  private

  # expire memoized objects here
  def self.refresh_session_if_expired(opts={})
    if @session.nil? || opts[:force_new] || (Time.now.utc + 10.minutes) >= @session.expires_at.utc
      @session, @s3 = nil
    end
  end

end