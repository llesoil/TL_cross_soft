#!/bin/sh

numb='2650'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 1.2 --qblur 0.4 --qcomp 0.7 --vbv-init 0.7 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 0 --keyint 210 --lookahead-threads 0 --min-keyint 27 --qp 50 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset veryslow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.0,1.0,1.1,1.2,0.4,0.7,0.7,3,1,12,0,210,0,27,50,5,4,62,48,4,2000,-2:-2,umh,show,veryslow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"