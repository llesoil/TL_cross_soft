#!/bin/sh

numb='2734'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 0.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.9 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 40 --keyint 210 --lookahead-threads 0 --min-keyint 25 --qp 40 --qpstep 3 --qpmin 1 --qpmax 65 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset veryslow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.0,1.2,1.1,0.8,0.6,0.7,0.9,1,2,6,40,210,0,25,40,3,1,65,28,4,2000,-2:-2,umh,show,veryslow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"