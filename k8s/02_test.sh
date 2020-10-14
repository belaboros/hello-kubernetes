

wget $(kubectl get services | grep hello-kubernetes | tr -s  " " | cut -d ' ' -f 3):80
echo "See downloaded file: index.html"


echo "Or open URL in a browser:"
echo "$(kubectl get services | grep hello-kubernetes | tr -s  " " | cut -d ' ' -f 3):80"