#!/bin/sh

numb='1116'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 45 --keyint 290 --lookahead-threads 4 --min-keyint 23 --qp 20 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset veryslow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.0,1.2,2.6,0.2,0.9,0.7,1,0,6,45,290,4,23,20,5,0,62,28,2,2000,-2:-2,dia,show,veryslow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"