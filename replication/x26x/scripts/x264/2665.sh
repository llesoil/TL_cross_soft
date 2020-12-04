#!/bin/sh

numb='2666'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 0.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.7 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 45 --keyint 260 --lookahead-threads 1 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,3.0,1.5,1.3,0.6,0.6,0.8,0.7,0,0,14,45,260,1,30,50,5,4,68,38,4,2000,-2:-2,dia,show,medium,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"