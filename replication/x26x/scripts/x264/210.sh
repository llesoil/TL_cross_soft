#!/bin/sh

numb='211'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 0 --keyint 250 --lookahead-threads 2 --min-keyint 24 --qp 40 --qpstep 4 --qpmin 4 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset veryfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,3.0,1.6,1.4,3.0,0.6,0.7,0.3,0,2,10,0,250,2,24,40,4,4,66,38,2,1000,-1:-1,umh,crop,veryfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"