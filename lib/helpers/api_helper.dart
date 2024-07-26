class ApiHelper {
  // Base URLs
  static const String domain = "http://127.0.0.1:8693";
  static const String baseurl = "$domain/api";

  // Auth Endpoints
  static const String registerJobseeker = "$baseurl/register-jobseeker";
  static const String registerEmployeer = "$baseurl/register-employeer";
  static const String loginurl = "$baseurl/login";
  static const String resetpassword = "$baseurl/reset-password";
  static const String checktoken = "$baseurl/check-token";
  static const String updatepassword = "$baseurl/update-password";

  // Job Posts Endpoints
  static const String jobPosts = "$baseurl/job-posts";

  // Job Seeker Endpoints
  static const String jsaccountverification = "$baseurl/jobseeker-verification";
  static const String jsProfileData = "$baseurl/jobseeker-profile-data";
  static const String jsProfileDataUpdate = "$baseurl/jobseeker-profile-data/update";
  static const String jsUploadCv = "$baseurl/jobseeker-upload-cv";
  static const String jsDownloadCv = "$domain/images/jobseeker/cv/";
  static const String jsApplyForJob = "$baseurl/jobseeker/apply-for-job";
  static const String jsCheckIfAppliedForJob = "$baseurl/jobseeker/job/check-if-already-applied";

  // Employer Endpoints
  static const String emaccountverification = "$baseurl/employer-verification";
  static const String emProfileData = "$baseurl/employer-profile-data";
  static const String emUpdateProfileData = "$baseurl/employer-profile-data-update";
  static const String emJobPosts = "$baseurl/employer-job-posts";
  static const String addJobPost = "$baseurl/employer-add-job-post";
  static const String updateJobPost = "$baseurl/employer-update-job-post";
  static const String removeJobPost = "$baseurl/employer-remove-job-post";
  static const String emAppliedJobseekers = "$baseurl/employer/job/applied-jobseekers";

  // Miscellaneous
  static const String trash = "$baseurl/";

  // Example method to generate URL with parameters
  static String jobDetailUrl(int jobId) {
    return "$jobPosts/$jobId";
  }
}
