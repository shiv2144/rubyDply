class UpdateJob
  include Wisper::Publisher

  def execute(performer, job, attributes)
    if job.update(attributes)
      broadcast(:update_job_successful, performer, job)
    else
      broadcast(:update_job_failed, performer, job)
    end
  end

end
