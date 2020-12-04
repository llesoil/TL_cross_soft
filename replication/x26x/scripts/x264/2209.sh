#!/bin/sh

numb='2210'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 2.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 14 --crf 0 --keyint 250 --lookahead-threads 3 --min-keyint 28 --qp 0 --qpstep 4 --qpmin 2 --qpmax 65 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.0,1.1,1.0,2.0,0.2,0.9,0.5,3,1,14,0,250,3,28,0,4,2,65,28,4,1000,-1:-1,umh,show,placebo,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"