#!/bin/sh

numb='3094'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 3.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 45 --keyint 200 --lookahead-threads 1 --min-keyint 20 --qp 10 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset ultrafast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.5,1.3,1.3,3.6,0.2,0.7,0.1,1,2,6,45,200,1,20,10,5,3,64,18,2,1000,-1:-1,umh,crop,ultrafast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"