#!/bin/sh

numb='40'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 3.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 45 --keyint 280 --lookahead-threads 4 --min-keyint 30 --qp 20 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset placebo --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.1,1.4,3.6,0.5,0.8,0.8,1,1,12,45,280,4,30,20,3,3,65,48,2,2000,1:1,umh,show,placebo,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"