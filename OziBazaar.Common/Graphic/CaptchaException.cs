using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace OziBazaar.Common.Graphic
{
    [Serializable]
    public class CaptchaException : Exception
    {
        public CaptchaException()
            : base() { }

        public CaptchaException(string message)
            : base(message) { }

        public CaptchaException(string format, params object[] args)
            : base(string.Format(format, args)) { }

        public CaptchaException(string message, Exception innerException)
            : base(message, innerException) { }

        public CaptchaException(string format, Exception innerException, params object[] args)
            : base(string.Format(format, args), innerException) { }

        protected CaptchaException(SerializationInfo info, StreamingContext context)
            : base(info, context) { }
    }
}


