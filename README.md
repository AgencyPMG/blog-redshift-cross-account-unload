# Cross Account Redshift UNLOAD/COPY with Terraform

Example terraform config for cross account redshift `UNLOAD` or `COPY`.

See [this blog post](https://www.pmg.com/blog/cross-account-redshift-unload-copy/)
for the why of all this.

- `redshift_account` should be applied to the AWS account that contains the
  redshift cluster.
- `s3_account` should be applied to the AWS account that will contain the target
  S3 bucket.
