#!/bin/sh

numb='232'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 35 --keyint 280 --lookahead-threads 0 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.5,1.0,1.2,2.0,0.3,0.8,0.2,0,1,8,35,280,0,28,40,5,3,63,18,2,1000,-2:-2,hex,show,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"