#!/bin/sh

numb='1998'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 3.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.7 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 45 --keyint 210 --lookahead-threads 0 --min-keyint 20 --qp 50 --qpstep 3 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset veryfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.3,1.4,3.4,0.3,0.7,0.7,1,1,6,45,210,0,20,50,3,1,61,18,3,2000,-1:-1,hex,crop,veryfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"