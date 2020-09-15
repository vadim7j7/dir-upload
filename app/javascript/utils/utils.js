import { DirectUpload } from '@rails/activestorage';

function objToGetParams(attributes = {}) {
  return Object.keys(attributes).map(key => `${key}=${decodeURIComponent(attributes[key])}`).join('&');
}

function getDirectUploadUrl(attributes = {}) {
  const metaElement = document.querySelector('meta[name=direct-upload-url]');
  const directUploadUrl = metaElement && metaElement.content;
  if (!directUploadUrl) {
    return null;
  }

  const getPrams = objToGetParams(attributes);

  return `${directUploadUrl}${getPrams ? `?${getPrams}` : ''}`;
}

export class Uploader {
  constructor(file, uploadProgress) {
    const url = getDirectUploadUrl({ path: file.path });
    this.upload = new DirectUpload(file, url, this);
    this.uploadProgress = uploadProgress;
  }

  uploadFile() {
    this.uploadProgress && this.uploadProgress(0);
    this.upload.create((error, blob) => {
      if (error) {
      } else {
      }
    });
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener('progress',
      event => this.directUploadDidProgress(event));
  }

  directUploadDidProgress(event) {
    const percent = event.loaded * 100 / event.total
    this.uploadProgress && this.uploadProgress(percent);
  }
}
