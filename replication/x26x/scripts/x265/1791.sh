#!/bin/sh

numb='1792'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.3 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 25 --keyint 250 --lookahead-threads 1 --min-keyint 29 --qp 30 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slower --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.5,1.4,1.2,4.8,0.4,0.8,0.3,2,1,4,25,250,1,29,30,4,0,69,38,4,1000,1:1,hex,show,slower,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"