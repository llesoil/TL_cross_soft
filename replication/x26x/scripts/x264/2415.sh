#!/bin/sh

numb='2416'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 1.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 15 --keyint 270 --lookahead-threads 0 --min-keyint 26 --qp 40 --qpstep 4 --qpmin 4 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset placebo --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.6,1.4,1.2,0.3,0.9,0.0,0,2,12,15,270,0,26,40,4,4,67,18,2,1000,1:1,dia,show,placebo,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"