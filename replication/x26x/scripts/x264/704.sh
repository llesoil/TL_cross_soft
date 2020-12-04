#!/bin/sh

numb='705'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 0.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 5 --keyint 200 --lookahead-threads 0 --min-keyint 30 --qp 10 --qpstep 3 --qpmin 4 --qpmax 69 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.6,1.3,0.6,0.3,0.9,0.0,1,2,10,5,200,0,30,10,3,4,69,18,2,2000,-2:-2,umh,show,faster,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"