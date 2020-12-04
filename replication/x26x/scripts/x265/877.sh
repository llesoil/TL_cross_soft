#!/bin/sh

numb='878'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 1.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 30 --keyint 290 --lookahead-threads 2 --min-keyint 23 --qp 50 --qpstep 4 --qpmin 1 --qpmax 61 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset veryslow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.4,1.0,1.4,0.5,0.6,0.1,1,2,0,30,290,2,23,50,4,1,61,48,2,2000,1:1,umh,show,veryslow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"