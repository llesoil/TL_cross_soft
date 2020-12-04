#!/bin/sh

numb='410'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 45 --keyint 270 --lookahead-threads 4 --min-keyint 27 --qp 40 --qpstep 4 --qpmin 1 --qpmax 61 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.0,1.3,1.1,4.2,0.6,0.8,0.4,0,0,14,45,270,4,27,40,4,1,61,48,1,1000,-2:-2,dia,show,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"