#!/bin/sh

numb='1118'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 2.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.7 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 5 --keyint 250 --lookahead-threads 0 --min-keyint 22 --qp 20 --qpstep 3 --qpmin 1 --qpmax 64 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,3.0,1.2,1.0,2.2,0.4,0.6,0.7,2,1,4,5,250,0,22,20,3,1,64,48,6,2000,1:1,dia,show,slow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"