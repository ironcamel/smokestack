class JobsController < ApplicationController

  before_filter :authorize, :except => [:index, :show]

  # GET /jobs
  # GET /jobs.xml
  def index

    limit=params[:limit].nil? ? 50 : params[:limit]

    @jobs = Job.find(:all, :select => "id, status, type, job_group_id, nova_revision, glance_revision, keystone_revision, msg, config_template_id, created_at, updated_at", :include => [:config_template, {:job_group => :smoke_test}], :order => "id DESC", :limit => limit)

    if params[:table_only] then
      render(:partial => "table", :locals => {:show_updated_at => false, :show_description => true})
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json  { render :json => @jobs }
        format.xml  { render :xml => @jobs }
      end
    end

  end

  # GET /jobs/1
  # GET /jobs/1.xml
  def show
    @job = Job.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @job, :include => :job_group }
      format.xml  { render :xml => @job, :include => :job_group }
    end
  end

  # POST /jobs
  # POST /jobs.xml
  def create
    @job = Job.new(params[:job])

    respond_to do |format|
      if @job.save
        format.html { redirect_to(@job, :notice => 'Job was successfully created.') }
        format.json  { render :json => @job, :status => :created, :location => @job }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @job.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job = Job.find(params[:id])
    json=@job.to_json
    xml=@job.to_xml
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.json  { render :json => json }
      format.xml  { render :xml => xml }
    end
  end
end
