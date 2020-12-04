#!/bin/sh

numb='2185'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 3.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 40 --keyint 250 --lookahead-threads 4 --min-keyint 28 --qp 10 --qpstep 3 --qpmin 3 --qpmax 61 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset ultrafast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.3,1.1,3.8,0.6,0.8,0.0,0,2,12,40,250,4,28,10,3,3,61,18,4,2000,1:1,hex,show,ultrafast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"