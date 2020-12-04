#!/bin/sh

numb='1649'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --intra-refresh --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.2 --psy-rd 3.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.2 --aq-mode 0 --b-adapt 2 --bframes 2 --crf 40 --keyint 230 --lookahead-threads 4 --min-keyint 29 --qp 50 --qpstep 4 --qpmin 2 --qpmax 68 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,None,None,--weightb,0.5,1.3,1.2,3.8,0.3,0.8,0.2,0,2,2,40,230,4,29,50,4,2,68,38,1,1000,-2:-2,dia,show,veryfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"