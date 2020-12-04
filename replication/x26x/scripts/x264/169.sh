#!/bin/sh

numb='170'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 3.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 45 --keyint 290 --lookahead-threads 2 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 3 --qpmax 67 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.0,1.1,1.2,3.2,0.2,0.8,0.6,2,2,4,45,290,2,27,10,5,3,67,28,3,2000,-2:-2,umh,show,faster,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"