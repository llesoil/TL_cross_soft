#!/bin/sh

numb='1668'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --intra-refresh --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 4.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 5 --keyint 210 --lookahead-threads 0 --min-keyint 28 --qp 30 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,None,--slow-firstpass,--weightb,0.5,1.5,1.2,4.6,0.2,0.7,0.9,1,0,16,5,210,0,28,30,4,2,62,38,1,1000,-2:-2,umh,show,medium,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"