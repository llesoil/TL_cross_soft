#!/bin/sh

numb='2050'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 2.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 5 --keyint 200 --lookahead-threads 2 --min-keyint 22 --qp 30 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset placebo --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,3.0,1.4,1.4,2.0,0.6,0.6,0.2,1,1,14,5,200,2,22,30,3,0,63,18,2,2000,-2:-2,dia,show,placebo,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"