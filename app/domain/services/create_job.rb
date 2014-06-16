class CreateJob
  include Wisper::Publisher

  def execute(performer, attributes)
    job = performer.company.jobs.new(attributes)
    if job.save
      # send_invite_email(performer, job)
      broadcast(:create_job_successful, performer, job)
    else
      broadcast(:create_job_failed, performer, job)
    end
  end
end
