#!/bin/sh

numb='1478'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 10 --keyint 250 --lookahead-threads 0 --min-keyint 24 --qp 50 --qpstep 4 --qpmin 4 --qpmax 67 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.5,1.0,1.3,4.4,0.3,0.6,0.3,2,0,16,10,250,0,24,50,4,4,67,38,3,2000,1:1,hex,crop,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"