#!/bin/sh

numb='2842'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 4.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 0 --crf 10 --keyint 270 --lookahead-threads 1 --min-keyint 26 --qp 10 --qpstep 4 --qpmin 3 --qpmax 60 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset superfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,2.0,1.2,1.0,4.6,0.4,0.8,0.4,1,0,0,10,270,1,26,10,4,3,60,48,4,2000,-2:-2,hex,crop,superfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"