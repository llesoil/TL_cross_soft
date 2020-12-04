#!/bin/sh

numb='2172'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 4 --crf 30 --keyint 230 --lookahead-threads 0 --min-keyint 28 --qp 0 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset placebo --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.0,1.4,1.2,4.8,0.3,0.7,0.3,1,2,4,30,230,0,28,0,5,4,60,48,6,2000,-2:-2,hex,show,placebo,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"