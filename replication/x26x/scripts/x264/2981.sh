#!/bin/sh

numb='2982'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 3.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 35 --keyint 230 --lookahead-threads 4 --min-keyint 27 --qp 0 --qpstep 5 --qpmin 4 --qpmax 65 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset placebo --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.5,1.1,1.0,3.6,0.2,0.9,0.7,2,2,2,35,230,4,27,0,5,4,65,28,5,2000,-2:-2,dia,show,placebo,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"