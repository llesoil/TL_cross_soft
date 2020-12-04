#!/bin/sh

numb='2009'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 2.2 --qblur 0.3 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 25 --keyint 200 --lookahead-threads 1 --min-keyint 25 --qp 20 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.1,1.0,2.2,0.3,0.7,0.4,2,2,16,25,200,1,25,20,4,0,60,18,5,1000,1:1,umh,crop,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"