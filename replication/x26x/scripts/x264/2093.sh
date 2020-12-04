#!/bin/sh

numb='2094'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 2.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.3 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 50 --keyint 200 --lookahead-threads 2 --min-keyint 26 --qp 40 --qpstep 3 --qpmin 2 --qpmax 69 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset veryfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.5,1.0,1.1,2.2,0.5,0.8,0.3,0,2,0,50,200,2,26,40,3,2,69,48,2,2000,1:1,hex,show,veryfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"