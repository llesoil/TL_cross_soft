#!/bin/sh

numb='730'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 50 --keyint 290 --lookahead-threads 2 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.4,1.0,2.2,0.4,0.9,0.3,2,2,10,50,290,2,30,50,5,1,67,48,5,1000,-2:-2,hex,crop,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"