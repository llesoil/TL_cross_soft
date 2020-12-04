#!/bin/sh

numb='1147'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 3.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.4 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 0 --keyint 290 --lookahead-threads 3 --min-keyint 24 --qp 0 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset ultrafast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.0,1.3,1.0,3.6,0.2,0.7,0.4,3,1,8,0,290,3,24,0,5,3,64,48,5,1000,-2:-2,umh,show,ultrafast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"