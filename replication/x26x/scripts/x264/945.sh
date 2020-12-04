#!/bin/sh

numb='946'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 0.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 20 --keyint 200 --lookahead-threads 4 --min-keyint 28 --qp 0 --qpstep 5 --qpmin 1 --qpmax 68 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.0,1.0,0.6,0.5,0.7,0.4,3,2,4,20,200,4,28,0,5,1,68,48,4,2000,-2:-2,umh,show,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"