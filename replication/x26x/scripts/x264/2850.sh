#!/bin/sh

numb='2851'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 1.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 16 --crf 45 --keyint 290 --lookahead-threads 4 --min-keyint 27 --qp 0 --qpstep 3 --qpmin 1 --qpmax 65 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset slow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.5,1.2,1.8,0.2,0.6,0.3,1,1,16,45,290,4,27,0,3,1,65,38,1,2000,-2:-2,umh,crop,slow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"